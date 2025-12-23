Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF63E6B26E
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 02:41:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 074B66B0088; Mon, 22 Dec 2025 21:41:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021F06B0089; Mon, 22 Dec 2025 21:41:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E70316B008A; Mon, 22 Dec 2025 21:41:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D318F6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 21:41:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 329231A0436
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:41:42 +0000 (UTC)
X-FDA: 84249185244.15.0769079
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id C9E061C000F
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 02:41:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XxNb50V8;
	spf=pass (imf20.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766457700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X76OLfq9JWE8CxaMPmo7L22pFIXt692o1JOaTWhrH84=;
	b=GPJU3xGrza/M26tGtyEYbB/zCeLui3LKVZeKY72zTSko84vac2a0ZJZ5PIhHnzzhvX7zkZ
	vzSzfirkn6RhvZrVrpqWulm5DkemF6yweS4QFCN0xN4h+k7x4WDuXsAehgUyvTP7ln2qx5
	KErlM7PWYUQmmqhF76YSouUz4WcsU4s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=XxNb50V8;
	spf=pass (imf20.hostedemail.com: domain of liwan@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwan@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766457700; a=rsa-sha256;
	cv=none;
	b=NCVjPJasN5C4DYex83EqpTK2GNadV9P+sBLHUBREqqbjZiCtXnXaUyBIZPFj5dp+uKGIAo
	VWRUAAyN4zdhbdTgJ6Jh0NyLkwDbc6UuLLotCEhHRDW/n4VRFZXHE8PJtAO+WnHEqXprcO
	j7o+UJQKQHYLNJYmB1RiUqhk0DM51Uw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766457699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=X76OLfq9JWE8CxaMPmo7L22pFIXt692o1JOaTWhrH84=;
	b=XxNb50V8HhjGE5gJcRZuYlMpq+q6vhDuz28khsXLGAxrZs1nqguO1ahUH9JX4lOjBmp8O0
	ItFvCl9SxRGZ3a+FmN8QZtk8GQEk/qFztPpGEu574QIGEvKABG5A1eW6mMGSbXtPlUtNt6
	5SWpqjMBtFm5mlW2E+Z3tbkxm5mcJuE=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-N3yOWPrbMnSpKKq-OKLltA-1; Mon, 22 Dec 2025 21:41:35 -0500
X-MC-Unique: N3yOWPrbMnSpKKq-OKLltA-1
X-Mimecast-MFC-AGG-ID: N3yOWPrbMnSpKKq-OKLltA_1766457695
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-bdced916ad0so8096498a12.0
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 18:41:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766457694; x=1767062494;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X76OLfq9JWE8CxaMPmo7L22pFIXt692o1JOaTWhrH84=;
        b=bZZaGR56zYiU3rRPWtq9KKULayJX3ql1/SlHyk0EjqZJ0fNf+DkIukJWnEAzVNYaXb
         cUZ+L1kjHzqgr2PelpGpJGZU4VxyvE8Qh+xfTQhZCmeS0NVcDjwDm7i4Dvj0vrIvk2vU
         3Qbuv/CLUi5514MMWa4M9zcb4Tz6FEowD7d2KBlf1VIlayq/yUeX/Yx7/OPPLgNtdjJm
         al8KtIKKEwxPv/uQ/Xv9eUaSmvv5zNxxF1j5Q/Np5h9KujGh0IVaoWWbbqlgxZokdoE/
         rTHUmLDV3kUIo1Ux9lEIAu67wRPYOwF46WWK2eJOaCw9IITB8oHLEOClla+s9zFZKO0a
         OWXQ==
X-Forwarded-Encrypted: i=1; AJvYcCVUL6CNd83ZOxNK+dIebShZDt95eWeZaNmpWyXBhWRB8yFZc49OBiQ87/8Mw7NX0IijWHmhZFq+zg==@kvack.org
X-Gm-Message-State: AOJu0YynHeeYylOmZMNSaC4hQDrvpc257H+dZrFOaTpJlTNyjsIi5zEP
	8SQG/r4/ho2aAA34Mdo4Ngy+ziwiXwlo9XSWQocZFFXGvd/FA4u4ZB9NUrueogm+4TpGdLB6vjt
	r9FTZTXYxuViQ2945saorrD3HFm67JuMVDcGskNLpoyR1FMo0xKO9vVFY9nbZ7MSO609lUmDjUF
	d/3V2kAshto29++rNCLHc5676Qda0=
X-Gm-Gg: AY/fxX6H2eE2LwQYcg8JHg0LvKMZxYCC7M4HMFTBDUXq4zSjyGJpVX6QiaSUoR32bCD
	fzD7JbsgyVyVDVXapx7Z+znFod7ybMHKEVuxXStSjuNaQvxO1xs4YYEg9+2peNdseKlmY1gvKw9
	18wkEDlhqw7s9R6s1YO6SZ+K26SG5DBgIAu09mUAU8ljbO+tr6j06Axa/jcTPsDR6rEZk=
X-Received: by 2002:a05:7300:de4b:b0:2a4:3593:6453 with SMTP id 5a478bee46e88-2b05ebd8d92mr9946619eec.3.1766457694563;
        Mon, 22 Dec 2025 18:41:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGpUovhZE5pBphm6qlEdgCz7WwEpmZEiTUnA6F9yN+mMZoFbFB7iUAcmRN4ioegFjm3mJuEAs51apuu9znPHw0=
X-Received: by 2002:a05:7300:de4b:b0:2a4:3593:6453 with SMTP id
 5a478bee46e88-2b05ebd8d92mr9946600eec.3.1766457694139; Mon, 22 Dec 2025
 18:41:34 -0800 (PST)
MIME-Version: 1.0
References: <20251221122639.3168038-1-liwang@redhat.com> <20251221122639.3168038-2-liwang@redhat.com>
 <20251221221052.3b769fc2@pumpkin> <CAEemH2f40t+4SsjL3Y=8Gid-CBMtf3eL1egsPKT1J_7LDbdWPQ@mail.gmail.com>
 <20251222094828.2783d9e5@pumpkin> <CAEemH2fsAmhAkGAQb9rtD2WLUc7QMb9Q5dusG3S8LsJbNKsO_Q@mail.gmail.com>
 <20251222180509.b12684e112195ac3f7ee9389@linux-foundation.org>
In-Reply-To: <20251222180509.b12684e112195ac3f7ee9389@linux-foundation.org>
From: Li Wang <liwang@redhat.com>
Date: Tue, 23 Dec 2025 10:41:22 +0800
X-Gm-Features: AQt7F2qOIZm0BvL9DLtEgZtZpeJWcVubMomV_2ll-92wfg8FBEaptjEpncVydpM
Message-ID: <CAEemH2dZ3DxDPWuV1Uze213CqoFHec9kK+MeteigGANYTUzbqA@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] selftests/mm/write_to_hugetlbfs: parse -s as size_t
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Laight <david.laight.linux@gmail.com>, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, Mark Brown <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Waiman Long <longman@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: j2O0jQhay67BkS-Hzf_jZdzJmQtYpZ1mhrhmG_8-q_g_1766457695
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Stat-Signature: yrc3eso5a54w9yqcd4jm9xiropbamo8d
X-Rspam-User: 
X-Rspamd-Queue-Id: C9E061C000F
X-HE-Tag: 1766457699-678599
X-HE-Meta: U2FsdGVkX194OnZzjQNOPldVj9mOYXW2J2o2gljOBoTON8rplZz+U7IFslEcfxZkTeV8e7mADmvRI9SQ2Ijt49PA0au7+TD0y8YqxzNWemGuFIQayY/Oef+79gGcvyfAaE2BLY3U55ZvNPO/WaerGS+cWkhOjk2Fwkzw3H8tC4VuqtK510kziYUFhUEeop2M7ttjPzY2gtdPLHmi8zOXu2Tr+hG6GFu1S0S9iIl7Jl0JisBvgf8neFMZx+Jbc+igQFR9nGJXPfXgIL57j3jMq6SrmaqT7H97PEqtHpgMCyb+iSuGdM5s+grt2Qr1z6aqCur4HUQLKFInagYYlA0K+6vcBH6elSVwiiRcgYt8t4gEddylsg516KUK6kvTU/HCEImq5SQBiJWh7jfOQ5EmsseN1qo2tLpOznABnx8tQH1FIh518R1TsP4B8jZVEgs4NqX9TWYW8lFg4sUDtb933YtgEY0YWZZ52PVB+CaLMHUq2s7dZ8xSI9/wMm62Zlvit13baaJEdohWW7QGl/vK2BMu6B31E6zvNGNGpCR38mW4IFX5mSdn4Olxl8PEFguDZkNZlkmK4y+LcNULo8GJ5td03dmGuWULICEJrjqKCq//HFpkKkNroq3VDfSglceechSAFP4y7qwxna3B77j2C+W76JYn3HBNNkisBBdOp6/4brMersIEBoXygUnfqxpGwi3C4yYfmVCA4kiDeBm2RMDyRT8pGAZA1JKRsXPxa/jRkb7F/yoAPT7atIqvjtTaV540RtSuv/SslsY9m5cmwAsqhTtnISfzi+gPYcirpY5RaGhnO7I0IsqVB3xiEZBn1+HjfMuVKPBx7praRarcqKDwq89IoQxLdkYWKjBBlHFLxKNxTapoRC0vHEKyboCW36fyvjlZhXqPB8Xr9U3MHGXbvqayMujSmY6vEiF4wUONIrH45t6OUSgTLlcUjTgJ+YV8UhLeiVDpyhN5ClA
 LDOep6vb
 er2zWclssIUfS0fZXfr6eO/ZpO+h79fPQC3CCA0klHRywpLaIdCIcOGSOXedPtfaP8Vg5abZy0RoDtG1hFLpT9F7ZVNkf8mw36uZWI1Ty8FiIqZJUbkYhhrVu3FIelTMU93o9L4DRp7wxBJXFSWh1/ORbfskPu2LHJxPHzyJqUtwXFtFK5SfMrDMcfhFyqDYjX1k0X8lqFsDru2RFYuaGQPpPXuIrINtCKZWKDTwPpCjvPwJIwBNpo5hj5qWdK47PRc6k9NR2/TeH396u/MwPwOPilK9suf2lXC8W4gyBvJ8v9OqqqrPdPqAtehvz2Kw/Cb6xP/gak9mg1dmRTwFDerXJ74fKYmTErdGTSLqXK1AXzYikvYUM6iPRq4DHfz8H+pFt3pSRq7fueHVlbCsAmW/jLYx0gxbyAC/Oo2zyAWkcIfjMyTKYVxkzu8A4KkHJiHumKTC6MbBZegiuHKixDbeZZ9Pt5dHufe/6/6ahSJG+mlsFXwGUoTyGKA3kt9FS4vzsfsKTiNwL4CXiO4K7UI30bjIq1WMYtwz+2etHXke+GekH2WNqL83znynlEqhjwbZNo8qmBWhRUPn2kzj/OizvX4Wtg51gQiIrJWVSwuMEwiiKjRsNN7lUjjSQxpBHF7vgB2k6Wwr2RXg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> wrote:

> > > It is best to use strtoul() and check the 'end' character is '\0'.
> >
> > Hmm, that sounds like we need to go back to the patch V1 [1] method.
> > But I am not sure, @Andrew Morton, do you think so?
> >
> > --- a/tools/testing/selftests/mm/write_to_hugetlbfs.c
> > +++ b/tools/testing/selftests/mm/write_to_hugetlbfs.c
> > @@ -86,10 +86,17 @@ int main(int argc, char **argv)
> >         while ((c = getopt(argc, argv, "s:p:m:owlrn")) != -1) {
> >                 switch (c) {
> >                 case 's':
> > -                       if (sscanf(optarg, "%zu", &size) != 1) {
> > -                               perror("Invalid -s.");
> > +                       char *end = NULL;
> > +                       unsigned long tmp = strtoul(optarg, &end, 10);
> > +                       if (errno || end == optarg || *end != '\0') {
> > +                               perror("Invalid -s size");
> >                                 exit_usage();
> >                         }
> > +                       if (tmp == 0) {
> > +                               perror("size not found");
> > +                               exit_usage();
> > +                       }
> > +                       size = (size_t)tmp;
> >                         break;
> >                 case 'p':
>
> Geeze guys, it's just a selftest.
>
> hp2:/usr/src/linux-6.19-rc1> grep -r scanf tools/testing/selftests | wc -l
> 177
>
> if your command line breaks the selftest, fix your command line?

Yes, I am ok with sscanf() :-).

In fact, write_to hugetlbfs currently only accepts arguments from
charge_reserved_hugetlb.sh, and the way the '-s' is used is not
very diverse.

--
Regards,
Li Wang


