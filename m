Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DDE4CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 15:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D9E68E0029; Wed, 20 Aug 2025 11:56:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B22B8E0003; Wed, 20 Aug 2025 11:56:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C8558E0029; Wed, 20 Aug 2025 11:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF1028E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:56:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7156C140511
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:56:27 +0000 (UTC)
X-FDA: 83797588014.27.AC3A45F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4836C8000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:56:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A2NtjjLl;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755705385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Er23qODQtG4idaztLuSjwC5wmfZWAF3dygpF7gAo74Q=;
	b=E6il+r24qKUiaPjcBaQatK4jfrBq8Wwkdfb8aQsD+Xn6oV8ERPrD+chZKtA6jIwbyzsTA6
	xDIXi3LqcQafubITQ2pseb9M1NOP3XAGJal55VOLNnzvTDXFJlmQscCJ5VZKig6pMTzyhV
	0tBPv6jRF0u4TAbVCUh2K0G0lgaMqxA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=A2NtjjLl;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755705385; a=rsa-sha256;
	cv=none;
	b=agNChFCumZxRwUtfsY7dKiASH33cWr8SW62077bySHQ/gsXpHYRv2GjovzAzWRMT11J0qT
	9vicpx3gOz4m5eJsuFKf1haTeTUxPbAfzzGB8DJ57aY+k9P2/Mz/K+W+Jv6UouPjkJINQ9
	61D+jkOcc0omEMwZsCzFC4fmcypavmg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755705384;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Er23qODQtG4idaztLuSjwC5wmfZWAF3dygpF7gAo74Q=;
	b=A2NtjjLlxaiCYVYCws2eZQpKLcUNANzn5d9BGPK9gCxPJHX+eSpsy/hwGDl9OJ9oX0H3rK
	zNtgCZ9cUGEllIKWLUny23PnfFe1g7x9tPPaMkOY+pP+DVRBKnqb8zTju8xDMNEcgo6LnJ
	imolLZcfPLZSVRXL1la5nAd9lOjHoBs=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-626-p9-kSnEENICjhLlaO8Bs9Q-1; Wed, 20 Aug 2025 11:56:23 -0400
X-MC-Unique: p9-kSnEENICjhLlaO8Bs9Q-1
X-Mimecast-MFC-AGG-ID: p9-kSnEENICjhLlaO8Bs9Q_1755705383
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-71d4d04fc4cso15080107b3.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:56:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755705383; x=1756310183;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Er23qODQtG4idaztLuSjwC5wmfZWAF3dygpF7gAo74Q=;
        b=kU8EUd3yLu2JZwTOoYwFMJW2Y8H5K5h373J3eWjYqbfRj5SPf0K9CHO7nQugBDTDRL
         Rybhc1Y1COeEQuFJ5RRKdyCs6fmkd2Ig2snsH2e85+o7Xv2ChNmv8jq9mBANHnI7Iws6
         v3qMJJSjQFvrIxs6HIXoAz7NjskoBIUMS5al4Mu1VXFgtmpIPJ3UphhYMs09J/MV2oYT
         jN3wTMOovPWXEBIPK7xV/evrgKwSH9kr4b8iA1V2V7+B1/lfd8P4nkhVUQLwZpZPpFSy
         N26dIXvdDt16e+E/rCaaDJYDbm6GRIbHqKanUDghfNZcIpKlqX2AWWl7Uf2Bqtqwqdah
         Ivhg==
X-Gm-Message-State: AOJu0YxMi1AiQ54oAs35Q08kxQLK6gG9vScg0KU1hytjAJo8VS+B/MaK
	CI1h8vAOcAQ9dwR8BoGICYaMC+8s3/Sz8Dbd2otze5D6zWO4pmuvmMUOUUcJhXCHTQXQ/0R6gs1
	15z2s87IRRemlXjIIWj5Q0HCV9d0YohpqHRXjjMYWybtHZBae/wtsi7uZ4JrREIfCx3bY1qAQUV
	JvM9x9bRqYcdSZmbTTUTsC/Qr2kYHqE1RDi7YWQA==
X-Gm-Gg: ASbGnctKkag8focA2FWwhtgP0hiFUhlfZ45iia7qcPB9w+5bIJQo0OWwWaNRqcPGavE
	PxhKaRLkU5N2mUZodF4Z84jhlcCEEOJKnXqyWUqLzh6/C3KG9PP5CTaayQ6UabUqNdQr+pC5xZz
	RgX9NcXj/qqFafeCCO2WUheqk=
X-Received: by 2002:a05:6902:2b85:b0:e94:fc8c:e1f6 with SMTP id 3f1490d57ef6-e950485820fmr102014276.5.1755705382718;
        Wed, 20 Aug 2025 08:56:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFS+QnZtdkkS1vjc4OhO99gWxx/B53oOwhGsZXtA1ANwD9WwiLwFVxw4OYIIrLt4QKiuxs/inUSPFs93SI8/Kk=
X-Received: by 2002:a05:6902:2b85:b0:e94:fc8c:e1f6 with SMTP id
 3f1490d57ef6-e950485820fmr101964276.5.1755705382248; Wed, 20 Aug 2025
 08:56:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <20250819145530.243e02184b743eb9ec506856@linux-foundation.org>
In-Reply-To: <20250819145530.243e02184b743eb9ec506856@linux-foundation.org>
From: Nico Pache <npache@redhat.com>
Date: Wed, 20 Aug 2025 09:55:56 -0600
X-Gm-Features: Ac12FXzgXuKDwPVbATQMmVh6NLWeMMDQC0r_rrDLYa5BGBJGyBVrKKAptFCfllU
Message-ID: <CAA1CXcDpRywoWKXyoJPBgs0TCbENooQsj+hDzYVhP4eYsiiFJw@mail.gmail.com>
Subject: Re: [PATCH v10 00/13] khugepaged: mTHP support
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, baohua@kernel.org, willy@infradead.org, 
	peterx@redhat.com, wangkefeng.wang@huawei.com, usamaarif642@gmail.com, 
	sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 3yAQ6sqLb1ocynZEyDSiHRUPLUxPZ7u_F1BnnfiAoA8_1755705383
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4836C8000D
X-Rspam-User: 
X-Stat-Signature: kuzzdhzohujd75pjh7ureeco1ghdjaog
X-Rspamd-Server: rspam09
X-HE-Tag: 1755705385-631798
X-HE-Meta: U2FsdGVkX1/bdHTwioyR+uooTdPy9f0Ubb0D62kjKvluvxRNAApXRogMvLupeSNcsbWeVcrfxqousfNNvyOhqmh33NVP+d2QauCmtdnrewUBWQoQJAU6uSK4SqXoHwEN9OngVBOMRxdLnorSXVwBGHqeR20c+ENA6hpVOhKMIPhYPDI1nY2ch6Fx+N/QoR6pX+CFPIZddGIVQXK4Le5qJsirWfooL85WYe2hVlP8FiL99RGZS3kHmrgjG8fFsReoWxLb7hx7qwGBkctMrbZSZnlyTsWgzga5FwA5171FwTk8ROnJZrwUEegeJAepLqHj960i2hWur7XQf0GAGe6XCTRO9pXWFliiha8sMhQv1HEGb+1zSNny+hRhP7X4AYqVl6HTAqIPyhbreFBGcOqRyO0Xcfm04Mx1iZtWWueqkVEn48+/cVoLjPwYXx/EUyQniCfDl3MqeWGevUNHzAe/9RmPpfsXjqyoJoZnkY85o3ozoY3fTkLhF41FG3bYRaqv1Ntba8kbu5FUzWwF5sUAdjICJYj8TMdw7kbFO/xNlUyarvVd7EwlNHuOyHZQfBx7/T9tXbwOWCnVtDmzUtcKdQtF9phBX/3kyPyHLYV4v0Jl1mtgdkx0YbijiGVFIUFmHA1oF7qhJ0LhvNvisjAEsA4FWB0CMlHwwjIiFXRshiY3hTncF+OghM0aKpzq/S3zIRNaPQswaD+V5DM6V8wnOs/fux4YVwT6SK10UI0L5kGR+C9K2NeJFY34Q6A02BPTmWv3bbR1tORhYlnFPp1JrEFJCWBQXQ6TaGDjIvmLlAmEGX8Cqr0BQGrf8YUeFdR25ewecsqjYxlHw3vf+w8RgZv82/QA59RupsY5o3+J5e3gEoWHqMWn2NebgH+xh48NO1hf7jRA6GS5RLGEPcLjSQ6dYyP9CG8zQBsTKvCaAMli24zuA3JfJHVTDlDjKBM3iXrDl8ZeLZ3NMEWLMKR
 oQ/9RDj1
 WZmp12NvhSKOaPQAfbqFZC6GyuURT1xTndiTf5ZBDwxix4VbMGIKaH1f2kL6GExfYva6w7UVN49f/67v72LQpOEBcJldlkHkfEvJ3ojqytcLAgtFJvOCe2u22IlZemALvoUm7nWPvbZOWt2mWnroavJ+gJ2jlSxwx2VCz8xyPT2ObBwnCywlM2GavtVnDWSsmXaNQ+RaZO1BrkSTbFE1f59K1PUffQg/KrqBOhclO2YdA1v1FRP3Oz1K2lHyuy7hACfXKKodvafxNkXnPsObWZROE3k4iY2KWUyi3yKpLWtmr4rFxAhtyhDm8c48hwgz2+J1Em9lzkNC9NeFBtz9SvOOnnDqUJBTHVB+hWTbPyPo9UndK7PpDFFdo2rvg0G9Q1V1myw7rkCbwdUkgJ3ZjvGjwSs9XUfnrBiZK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 3:55=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Tue, 19 Aug 2025 07:41:52 -0600 Nico Pache <npache@redhat.com> wrote:
>
> > The following series provides khugepaged with the capability to collaps=
e
> > anonymous memory regions to mTHPs.
> >
> > ...
> >
> > - I created a test script that I used to push khugepaged to its limits
> >    while monitoring a number of stats and tracepoints. The code is
> >    available here[1] (Run in legacy mode for these changes and set mthp
> >    sizes to inherit)
>
> Could this be turned into something in tools/testing/selftests/mm/?
Yep! I was actually working on some selftests for this before I hit a
weird bug during some of my testing, which took precedence over that.

I was planning on sending a separate series for the testing. One of
the pain points was that selftests helpers were set up for PMDs, but I
think Baolin just cleaned that up in his khugepaged mTHP shmem series
(still need to review). So it should be a lot easier to implement now.
>
> > V10 Changes:
>
> I'll add this to mm-new, thanks.  I'll suppress the usual emails.
Thank you :)
-- Nico
>


